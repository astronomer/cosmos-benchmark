{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01323') }},
        {{ ref('model_01202') }}
)
select id, 'model_02234' as name from sources
