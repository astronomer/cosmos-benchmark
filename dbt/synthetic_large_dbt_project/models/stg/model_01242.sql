{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00627') }},
        {{ ref('model_00054') }}
)
select id, 'model_01242' as name from sources
