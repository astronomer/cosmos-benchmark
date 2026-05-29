{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01859') }},
        {{ ref('model_01530') }},
        {{ ref('model_01848') }}
)
select id, 'model_02848' as name from sources
