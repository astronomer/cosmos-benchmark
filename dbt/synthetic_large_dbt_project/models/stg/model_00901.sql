{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00133') }},
        {{ ref('model_00494') }},
        {{ ref('model_00499') }}
)
select id, 'model_00901' as name from sources
