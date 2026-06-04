{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00975') }},
        {{ ref('model_01053') }}
)
select id, 'model_01858' as name from sources
