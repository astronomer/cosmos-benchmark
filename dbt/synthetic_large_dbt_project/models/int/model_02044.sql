{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00816') }},
        {{ ref('model_01051') }}
)
select id, 'model_02044' as name from sources
