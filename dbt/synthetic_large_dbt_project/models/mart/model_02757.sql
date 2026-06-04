{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01680') }},
        {{ ref('model_01795') }},
        {{ ref('model_02061') }}
)
select id, 'model_02757' as name from sources
