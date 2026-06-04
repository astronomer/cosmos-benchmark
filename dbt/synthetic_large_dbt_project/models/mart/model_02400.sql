{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01738') }},
        {{ ref('model_01722') }}
)
select id, 'model_02400' as name from sources
