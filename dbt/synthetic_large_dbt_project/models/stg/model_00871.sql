{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00305') }},
        {{ ref('model_00423') }},
        {{ ref('model_00055') }}
)
select id, 'model_00871' as name from sources
