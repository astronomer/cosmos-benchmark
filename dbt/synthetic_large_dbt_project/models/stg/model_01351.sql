{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00381') }},
        {{ ref('model_00012') }}
)
select id, 'model_01351' as name from sources
