{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01784') }}
)
select id, 'model_02348' as name from sources
