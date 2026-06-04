{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00100') }},
        {{ ref('model_00463') }},
        {{ ref('model_00507') }}
)
select id, 'model_01315' as name from sources
