{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00381') }},
        {{ ref('model_00020') }}
)
select id, 'model_00844' as name from sources
