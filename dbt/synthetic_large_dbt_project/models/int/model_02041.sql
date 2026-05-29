{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01468') }},
        {{ ref('model_01101') }},
        {{ ref('model_01377') }}
)
select id, 'model_02041' as name from sources
