{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01089') }},
        {{ ref('model_01240') }}
)
select id, 'model_01876' as name from sources
