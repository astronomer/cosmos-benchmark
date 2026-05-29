{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00429') }},
        {{ ref('model_00170') }},
        {{ ref('model_00423') }}
)
select id, 'model_00817' as name from sources
